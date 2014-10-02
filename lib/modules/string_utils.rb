module StringUtils

  # Sets the first letter of a string uppcase and the others downcase
  def self.first_letter_uppercase(str)
    if str.blank?
      return ""
    else
      str.strip!
      return str[0].upcase + str[1..str.length].downcase
    end
  end
  
  # Sets every first letter of a string uppcase and the others downcase 
  def self.every_first_letter_uppercase(str)
    if str.blank?
      return ""
    else
      @result_array = []
      # Si plusieurs éléments sont entrés, chacun est mis dans un tableau
      @text_array = str.strip.split  
      @text_array.each do |str|
        # On parcourt le tableau et on met la première lettre en majuscules et les autres en minuscule
        @result_array << "#{str[0].upcase + str[1..str.length].downcase}"
      end
      # On colle les éléments du tableau en les séparant par un espace
      return @result_array.join(" ") 
    end
  end
  
end
