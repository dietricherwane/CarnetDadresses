module PreviousJobExperiencesHelper
  def previous_job_experience_messages!
    return "" if @previous_job_experience.errors.empty?
    
    [:error, :alert, :success, :notice].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end
    
    messages!
  end
end
