json.extract! post, :id, :title, :description, :published, :favorite, :user_id, :created_at, :updated_at
json.url post_url(post, format: :json)
