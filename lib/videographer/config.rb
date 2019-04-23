require 'active_support/core_ext/class/attribute_accessors'

class Videographer::Config
  cattr_accessor :aws_region, :aws_id, :aws_secret
end
