namespace :city_images do
  desc 'Imports city images from a folder'
  task import: :environment do
    image_names = Dir.glob("#{Rails.root}/db/images/*")
    image_names.each do |image_name|
      begin
        lowcase_city = image_name.split('/').last.split('.').first.downcase.gsub('_', ' ')
        city = City.where("lower(name) = '#{lowcase_city}'").first
        city.photos << Photo.new(attachment: File.open(image_name)) unless city.photos.any?
        puts "Uploaded #{image_name}"
      rescue
        puts "---------------------Couldn't upload image for #{image_name}"
      end
    end
  end
end