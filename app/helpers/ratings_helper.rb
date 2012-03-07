module RatingsHelper
  def parse_review (params)
    overall, count = 0, 0
    js = params[:rating].inject([]) do |rev, kv|
      overall += kv[1].to_i
      count += 1
      rev << {"rating_id" => kv[0], "value" => kv[1].to_i}
    end.to_json
    return js, overall, count
  end
end