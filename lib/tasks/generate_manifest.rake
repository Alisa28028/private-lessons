namespace :manifest do
  desc "Generate static manifest.json from ERB template"
  task generate: :environment do
    template_path = Rails.root.join("app/assets/config/manifest.json.erb")
    output_path = Rails.root.join("public/manifest.json")

    files = Dir.entries(Rails.root.join("app/assets/images/icons/")).select { |f| !File.directory?(f) }

    # Instead of ERB, build JSON directly here to avoid helper issues:
    icons = files.map do |file|
      match = file.match(/.+-(?<size>\d{2,3}x\d{2,3})\.png/)
      {
        src: "/assets/icons/#{file}",
        sizes: match ? match[:size] : "",
        type: "image/png"
      }
    end

    manifest_hash = {
      description: "Private lesson is an online booking management system that helps dance teachers manage their classes and save time!",
      display: "fullscreen",
      name: "Private Lessons",
      icons: icons
    }

    File.open(output_path, "w") do |f|
      f.write(JSON.pretty_generate(manifest_hash))
    end

    puts "Generated #{output_path}"
  end
end
