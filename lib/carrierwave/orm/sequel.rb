require 'sequel'
 
module CarrierWave
  module Sequel
 
    include CarrierWave::Mount
 
    def mount_uploader(column, uploader)
      super
 
      alias_method :read_uploader, :[]
      alias_method :write_uploader, :[]=
 
      after_save "store_#{column}!"
      before_save "write_#{column}_identifier"
      before_destroy "remove_#{column}!"
    end
 
    # Determine if we're using Sequel > 2.12
    #
    # ==== Returns
    # Bool:: True if Sequel 2.12 or higher False otherwise
    def self.new_sequel?
      ::Sequel::Model.respond_to?(:plugin)
    end
 
  end # Sequel
end # CarrierWave
 
# Sequel 3.x.x removed class hook methods and moved them to the plugin
Sequel::Model.plugin(:hook_class_methods) if CarrierWave::Sequel.new_sequel?
Sequel::Model.send(:extend, CarrierWave::Sequel)
