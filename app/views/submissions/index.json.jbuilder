json.array!(@submissions) do |submission|
  json.extract! submission, :id, :word
  json.url submission_url(submission, format: :json)
end
