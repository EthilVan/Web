# encoding: UTF-8
class AddStatusToPostulations < ActiveRecord::Migration

  def up
    add_column :postulations, :status, :integer, :default => 0
    Postulation.all.each { |p|
        if p.validated?
            p.status = 2
        else
            p.status = 0
        end
        p.save
    }
  end

  def down
    remove_column :postulations, :status
  end
  
end
