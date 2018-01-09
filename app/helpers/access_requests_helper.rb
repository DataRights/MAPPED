module AccessRequestsHelper
  def get_sectors(campaign)
    return [] unless campaign
    return [] unless campaign.is_a? Campaign
    return Sector.all.map { |sector| [sector.name, sector.id] } if campaign.name == Campaign::DEFAULT_CAMPAIGN_NAME
    campaign.organizations.map(&:sector).map {|sector| [sector.name, sector.id]}.uniq
  end

  def get_campaign_organizations(campaign, sector)
    return [] unless campaign
    return [] unless campaign.is_a? Campaign
    return [] unless sector
    return [] unless sector.is_a? Sector
    return Organization.where(sector: sector).map {|organization| [organization.name, organization.id]}.uniq if campaign.name == Campaign::DEFAULT_CAMPAIGN_NAME
    campaign.organizations.where(sector: sector).map {|organization| [organization.name, organization.id]}.uniq
  end

  def generate_question_view(question)
    result = ''
    return result unless question
    return result unless question.is_a? Question
    result = question.title + ' <br />'
    case question.type
    when 'QuestionSimple'
      result += generate_simple_question(question)
    when 'QuestionMultiple'
      result += generate_multiple_question(question)
    when 'QuestionSelectList'
      result += generate_select_question(question)
    end
    result
  end

  protected

  def generate_simple_question(question)
    return '' unless question.is_a? QuestionSimple
    if question.metadata['answer_type'] == 'text'
      return text_field_tag(attribute_id(question), nil, required: question.mandatory) unless question.visuals
      if question.visuals['rows'].nil? || question.visuals['rows'] == 1
        return text_field_tag(attribute_id(question), nil, required: question.mandatory) unless question.visuals['cols']
        return text_field_tag(attribute_id(question),'', size: question.visuals['cols'], required: question.mandatory)
      else
        return text_area_tag(attribute_id(question), nil, rows: question.visuals['rows'], required: question.mandatory)  unless question.visuals['cols']
        return text_area_tag(attribute_id(question), nil, rows: question.visuals['rows'], cols: question.visuals['cols'], required: question.mandatory)
      end
    elsif question.metadata['answer_type'] == 'number'
      return number_field_tag(attribute_id(question),nil, required: question.mandatory)
    elsif question.metadata['answer_type'] == 'boolean'
      return check_box_tag(attribute_id(question),nil, required: question.mandatory)
    elsif question.metadata['answer_type'] == 'date'
      return date_field_tag(attribute_id(question),nil, required: question.mandatory)
    elsif question.metadata['answer_type'] == 'time'
      return time_field_tag(attribute_id(question),nil, required: question.mandatory)
    end
  end

  def generate_multiple_question(question)
    result = ''
    return result unless question.is_a? QuestionMultiple
    question.metadata['option_list'].each do |option|
        result += check_box_tag(attribute_id(question)+'[]', option, required: question.mandatory, class: 'form-check-input')
        result += " #{option} <br>"
    end
    result
  end

  def generate_select_question(question)
    result = ''
    return result unless question.is_a? QuestionSelectList
    return select_tag(attribute_id(question), options_for_select(question.metadata['option_list']), required: question.mandatory, class: 'form-control') unless question.visuals
    if question.visuals['select_type'].nil? || question.visuals['select_type'] == 'select'
      result = select_tag(attribute_id(question), options_for_select(question.metadata['option_list']), required: question.mandatory, class: 'form-control')
    elsif question.visuals['select_type'] == 'radio'
      sperator = question.visuals['direction'] == 'horizontal' ? '&nbsp;&nbsp;' : '<br>'
      question.metadata['option_list'].each do |option|
          result += radio_button_tag(attribute_id(question)+'[]', option, required: question.mandatory, class: 'form-check-input')
          result += " #{option} #{sperator}"
      end
    end
    result
  end

  def attribute_id(question)
    "answers[#{question.id}]"
  end
end
