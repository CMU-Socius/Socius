json.array!(@orgs) do |organization|
  json.extract! organization, :id, :name
  json.members organization.users.size
  json.url organization_url(organization, format: :json)
end