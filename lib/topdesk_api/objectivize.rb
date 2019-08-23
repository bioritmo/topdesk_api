module TopdeskAPI
  module Objectivize
    def objectivize(body)
      return if body.nil? || body.empty?

      body.each do |name, value|
        singleton_class.class_eval { attr_accessor name }
        send("#{name}=", value)
      end
      self
    end
  end
end
