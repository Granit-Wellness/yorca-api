require_relative '../app'

puts "Creating drugs....."

def fixture_data(path)
  File.open("lib/fixtures/#{path}", 'rb').read
end

def fixture_json(path)
  JSON.parse(fixture_data(path))
end

drugs = fixture_json('drugs.json')

drugs.each do |drug|
  return unless drug["model"] == 'drugs.drug'
  puts "Creating #{drug["fields"]["name"]}...."

  drug_fields = drug["fields"]
  Models::Drug.create(
    name: drug_fields["name"],
    description: drug_fields["description"],
    avatar_uri: drug_fields["image"],
    external_resource_url: drug_fields["additional_media"],
    aliases: drug_fields['aliases'].to_a,
    effects: drug_fields['effects'].to_a,
    health_risks: drug_fields['health_risks'].to_a,
  )
  puts '..'
end



