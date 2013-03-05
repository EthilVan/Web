module EthilVan::App::Views

   module Member::Activity

      def self.for(model)
         const_get(model.subject.class.name, false).new(model)
      end

      class ActivityPartial < Partial

         def initialize(model)
            @model = model
         end

         def actor_avatar
            @model.actor.profil.avatar_url
         end

         def actor_name
            @model.actor.name
         end

         def actor_url
            urls.profil(@model.actor)
         end

         def actor_is_viewer?
            current? @model.actor
         end

         def action
            @model.action
         end

         def _subject
            @model.subject
         end

         def subject_is_viewer?
            false
         end

         def render_activity
            subject_dir = _subject.class.model_name.i18n_key
            partial "activity/#{subject_dir}/#{action}"
         end

         def date_ago
            time_ago_in_words(@model.created_at)
         end
      end
   end
end
