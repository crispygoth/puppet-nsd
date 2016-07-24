#
# validate_nsd_acl.rb
#

require 'ipaddr'

# Patch IP class so the netmask is accessible
class IPAddr
  attr_reader :mask_addr
end

module Puppet::Parser::Functions
  newfunction(:validate_nsd_acl, :type => :rvalue, :doc => <<-EOS
    Validate that all passed values are all valid IP addresses. A second
    argument passes one or more fixed strings that are valid values in
    addition to TSIG key names. A third argument passes one or more fixed
    strings to verify an optional parameter preceding the IP address. A
    final fourth parameter controls if the IP address accepts single
    addresses or CIDR, IP & netmask, or IP-IP ranges. The return value is
    an array of all unique TSIG key names, not including any strings
    passed in the second parameter.

    Example:

      validate_nsd_acl(['1.2.3.4 NOKEY', '5.6.7.8 test'], ['NOKEY'])
      validate_nsd_acl(['AXFR 1.2.3.0/24 NOKEY'], ['NOKEY'], ['AXFR'], true)

    Would return:

      ['test']
      []
    EOS
  ) do |arguments|

    rescuable_exceptions = [ArgumentError]

    if defined?(IPAddr::InvalidAddressError)
      rescuable_exceptions << IPAddr::InvalidAddressError
    end

    raise Puppet::ParserError, 'validate_nsd_acl(): Wrong number of ' +
      "arguments given (#{arguments.size} for 4)" unless (1..4).include?(arguments.size)

    item         = arguments[0]
    key_patterns = arguments[1] || []
    opt_patterns = arguments[2] || []
    extended     = function_str2bool([arguments[3] || false])

    unless item.is_a?(Array)
      item = [item]
    end

    if item.size == 0
      raise Puppet::ParseError, 'validate_nsd_acl(): Requires an array ' +
        'with at least 1 element'
    end

    keys = []

    item.each do |i|
      unless i.is_a?(String)
        raise Puppet::ParseError, 'validate_nsd_acl(): Requires either ' +
          'an array or string to work with'
      end

      spec = i.split(/\s+/)

      case spec.size
      when 1
        # Just the address
        addr = spec[0]
        # If there is at least one TSIG pattern then they're required
        if key_patterns.size > 0
          raise Puppet::ParseError, 'validate_nsd_acl(): A TSIG key is ' +
            'expected'
        end
      when 2
        # An address followed by a TSIG key
        addr = spec[0]
        unless key_patterns.include?(spec[1])
          keys << spec[1]
        end
      when 3
        # An address preceded by an option and followed by a TSIG key
        addr = spec[1]
        unless opt_patterns.include?(spec[0])
          raise Puppet::ParseError, 'validate_nsd_acl(): Unknown option ' +
            "#{spec[0].inspect}"
        end
        unless key_patterns.include?(spec[2])
          keys << spec[2]
        end
      else
        raise Puppet::ParseError, "#{i.inspect} is not a valid NSD IP address."
      end

      # Match <address>@<port> syntax
      if addr =~ /^ ([^@]+) @ (\d+) $/x
        ip = $1
        unless $2.to_i < 65535
          raise Puppet::ParseError, "#{$2} is not a valid port."
        end
      else
        ip = addr
      end

      # Match extended IP address formats
      if extended
        case ip
        when /^ ([^\/]+) \/ (\d+) $/x
          # IP / Prefix
          begin
            unless IPAddr.new($1).mask($2).mask_addr.to_s(2).count('1') == $2.to_i
              raise Puppet::ParseError, "#{ip.inspect} is not a valid IP/Prefix pair."
            end
          rescue *rescuable_exceptions
            raise Puppet::ParseError, "#{ip.inspect} is not a valid IP/Prefix pair."
          end
        when /^ ([^&]+) & (.+) $/x
          # IP & Mask
          begin
            x = IPAddr.new($1).mask($2)
            unless IPAddr.new(x.mask_addr, x.family).to_s == $2
              raise Puppet::ParseError, "#{ip.inspect} is not a valid IP/Mask pair."
            end
          rescue *rescuable_exceptions
            raise Puppet::ParseError, "#{ip.inspect} is not a valid IP/Mask pair."
          end
        when /^ ([^-]+) - (.+) $/x
          # IP-IP range
          range = [$1, $2].map do |x|
            begin
              IPAddr.new(x)
            rescue *rescuable_exceptions
              raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address range."
            end
          end
          if range[0].family != range[1].family or range[0] >= range[1]
            raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address range."
          end
        else
          # Normal IP
          begin
            x = IPAddr.new(ip)
            unless (x.ipv4? or x.ipv6?) and x.to_s.eql?(ip) and x.to_range.count == 1
              raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address."
            end
          rescue *rescuable_exceptions
            raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address."
          end
        end
      else
        # Normal IP
        begin
          x = IPAddr.new(ip)
          unless (x.ipv4? or x.ipv6?) and x.to_s.eql?(ip) and x.to_range.count == 1
            raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address."
          end
        rescue *rescuable_exceptions
          raise Puppet::ParseError, "#{ip.inspect} is not a valid IP address."
        end
      end
    end
    keys.uniq
  end
end
