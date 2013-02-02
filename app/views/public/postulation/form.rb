module EthilVan::App::Views

   module Public::Postulation

      class Formulaire::Form < EthilVan::Mustache::ModelForm

         class ScreenForm < EthilVan::Mustache::ModelForm

            def initialize(screen, base_name, index)
               super(screen, base_name)
               @index = index
            end

            def field_name(name)
               "#@base_name[screens][][#{name}]"
            end

            def field_id(name)
               "#{@base_name}_screen_#{name}_#@index"
            end

            def screen_title
               "Screenshot #@index"
            end

            def url
               text :url
            end

            def description
               text :description
            end
         end

         def initialize(postulation)
            super(postulation)
         end

         def name
            text :name
         end

         def minecraft_name
            text :minecraft_name
         end

         def email
            text :email
         end

         def password
            text :password, type: :password
         end

         def password_confirmation
            text :password_confirmation, type: :password
         end

         def birthdate
            text :birthdate_formatted
         end

         def sexe
            select :sexe, Hash[*EthilVan::Data::Sexe.map(&:reverse).flatten]
         end

         def minecraft_since
            text :minecraft_since
         end

         def multi_minecraft
            checkbox :multi_minecraft
         end

         def old_server
            text :old_server
         end

         def old_server_reason
            text :old_server_reason
         end

         def ethilvan_discovered
            text :ethilvan_discovered
         end

         def ethilvan_reason
            text :ethilvan_reason
         end

         def availability
            text :availability_schedule
         end

         def microphone
            checkbox :microphone
         end

         def mumble
            select :mumble, EthilVan::Data::Mumble
         end

         def mumble_other
            text :mumble_other
         end

         def free_text
            text :free_text
         end

         def screen_template
            ScreenForm.new(PostulationScreen.new, @base_name, 0)
         end

         def screens
            @model.screens.each_with_index.map do |screen, i|
               ScreenForm.new(screen, @base_name, i + 1)
            end
         end

         def rules_acceptance
            checkbox :rules_acceptance
         end
      end
   end
end
