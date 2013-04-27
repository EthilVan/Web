# encoding: utf-8

require 'fileutils'
require 'securerandom'

class EthilVan::App

   get '/membre/upload' do
      view Views::Member::Upload.new
      mustache 'membre/upload'
   end

   post '/membre/upload' do
      upload(params['file'])
   end

   helpers do

      def upload(upload)
         if not upload.key?(:filename) or not upload.key?(:tempfile)
            return [500, "Paramètres invalides"]
         end

         subfolder = current_account.name
         folder = File.join(EthilVan::Config.upload_folder, subfolder)
         filename = SecureRandom.hex(20) + File.extname(upload[:filename])
         dest = File.join(folder, filename)

         FileUtils.mkdir_p folder
         File.open(dest, 'wb') do |destfile|
            destfile.write(upload[:tempfile].read)
         end

         "#{EthilVan::Config.upload_url}/#{subfolder}/#{filename}"
      rescue Exception => exc
         [500, exc.message]
      end
   end
end
