module EthilVan::App::Views

   module Member::Profil

      class Tags < PageTab

         class Form < EthilVan::Mustache::Form

            def initialize(tag, action)
               super(tag, action: action)
            end

            def tagger
               text :tagger
            end

            def contents
               text :content, validations: {
                  minlength: 2,
                  maxlength: 300,
               }
            end
         end

         def initialize(page, account, new_tag, tags)
            super(page, 'tags')
            unless new_tag.nil?
               @form = Form.new(new_tag, urls::Member::Profil.tags(account))
            end
            @tags = tags
         end

         def form
            @form
         end

         def tags?
            @tags.present?
         end

         def tags
            @tags.map do |tag|
               tagger = tag.tagger
               {
                  contents: tag.content,
                  tagger: tagger.name,
                  tagger_url: urls::Member::Profil.show(tagger),
                  tagger_avatar: tagger.profil.avatar_url,
                  date: I18n.l(tag.created_at)
               }
            end
         end
      end
   end
end
