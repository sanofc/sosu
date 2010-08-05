require 'yaml/store'

array = {
	"username" => "sosu.bot",
	"password" => "sosu.bot",
	"previous_tweet"=> "test"
}
puts YAML.dump(array)
db = YAML::Store.new('./test.yaml')
db.transaction do
	db["username"] = "sosu.bot",
	db["password"] = "sosu.bot",
	db["previous"] = "test"
end

