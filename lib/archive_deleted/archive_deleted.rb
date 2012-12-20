module ArchiveDeleted
	module ArchiveDeleted
		extend ActiveSupport::Concern
		
		included do
		end
		
		module ClassMethods
	    	def archive_deleted
	    		send :include, InstanceMethods
	    		send :after_destroy, :archive_deleted_ar
	    	end

	    	def deleted_since(t, use_sti = true)
	    		return ArchivedObject.where("false") if t.nil?
	    		class_name = self.to_s
	    		sub_class_name = nil
	    		if self.new.respond_to?(:type) && use_sti
	    			class_name = self.superclass.to_s
	    			sub_class_name = self.to_s
	    			return ArchivedObject.where(["class_name = ? AND sub_class_name = ? AND deleted_at > ?", class_name, sub_class_name, t]).order("deleted_at ASC")
	    		else
	    			return ArchivedObject.where(["class_name = ? AND deleted_at > ?", class_name, t]).order("deleted_at ASC")
	    		end
	    	end

	    	def modified_since(t)
	    		t = 0 if t.nil?
	    		return self.where(["updated_at > ? OR created_at > ?", t, t]).order("updated_at ASC")
	    	end

	    	def changed_since?(t, use_sti = true)
	    		return true if t.nil?

	    		class_name = self.to_s
	    		sub_class_name = nil
	    		if self.new.respond_to?(:type) && use_sti
	    			class_name = self.superclass.to_s
	    			sub_class_name = self.to_s
	    			ao = ArchivedObject.where(["class_name = ? AND sub_class_name = ? AND deleted_at > ?", class_name, sub_class_name, t])
	    		else
	    			ao = ArchivedObject.where(["class_name = ? AND deleted_at > ?", class_name, t])
	    		end

	    		return (self.where(["updated_at > ? OR created_at > ?", t, t]).count) > 0 || (ao.count > 0)
	    	end
	  	end
	
		def archive_deleted_ar
			class_name = self.class.to_s
			sub_class_name = nil
			if self.respond_to?(:type)
				class_name = self.class.superclass.to_s
				sub_class_name = self.class.to_s
			end
			schedule_id = self.respond_to?(:schedule_id) ? self.schedule_id : nil
			user_id = self.respond_to?(:user_id) ? self.user_id : nil
			
			a = ArchivedObject.new(:schedule_id => schedule_id, :o_id => self.id, :class_name => class_name, :sub_class_name => sub_class_name, :json_attributes => self.attributes.to_json)
			a.save!
		end
	end
end

ActiveRecord::Base.send :include, ArchiveDeleted::ArchiveDeleted