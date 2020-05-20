# Encapsulates the @all functionality

module Memoable
  module InstanceMethods
    def save
      tap { |me| self.class.all << me }
    end
  end

  module ClassMethods
    # lets the class define a generate_all method
    # defaults to empty array if none given
    def all
      if @all.nil? && defined?(generate_all)
        @all = []
        generate_all
      end
      @all ||= []
    end

    def count
      all.size
    end
  end
end
