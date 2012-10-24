# encoding: UTF-8
class AddWidthAndHeightToPostulationScreens < ActiveRecord::Migration

  def up
    add_column :postulation_screens, :width, :integer, :default => 900
    add_column :postulation_screens, :height, :integer, :default => 500

    PostulationScreen.all.each do |s|
        uri = URI.parse(s.url)
        say_with_time "Getting screen #{s.id} and updating size" do
            response = Net::HTTP.get_response(uri)
            avalaible = !(response.header.content_type =~ /^image/).nil?
            if avalaible
                im = ImageSize.new(response.body)
                say "Screen size : #{im.width} - #{im.height}"
                if (im.width > 900)
                    s.width = 900
                    s.height = (im.height * (900.0 / im.width)).to_i
                else
                    s.width = im.width
                    s.height = im.height
                end
                s.save
                say "Size of screens #{s.id} changed to #{s.width} - #{s.height}"
            end
        end
    end
  end

  def down
    remove_column :postulation_screens, :width
    remove_column :postulation_screens, :height
  end
  
end
