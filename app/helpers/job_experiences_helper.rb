module JobExperiencesHelper

  def job_experience_messages!
    return "" if @job_experience.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end

end
