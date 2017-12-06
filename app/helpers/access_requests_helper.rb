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
    return Organization.where(sector: sector).map {|organization| [organization.name, organization.id]} if campaign.name == Campaign::DEFAULT_CAMPAIGN_NAME
    campaign.organizations.where(sector: sector).map {|organization| [organization.name, organization.id]}
  end

  def get_template(user, campaign, organization)
    return nil unless user
    return nil unless user.is_a? User
    return nil unless campaign
    return nil unless campaign.is_a? Campaign
    return nil unless organization
    return nil unless organization.is_a? Organization
    sector = organization.sector
    return nil unless sector

    expected_langs = organization.languages
    accepted_versions = []
    active_templates = sector.templates.joins(:template_versions).where(:template_versions => {:active => true})
    active_templates.each do |template|
      template.template_versions.where(:active => true).each do |active_version|
        accepted_versions << active_version if expected_langs.include? active_version.language.to_sym
      end
    end
    return nil if active_versions.blank?
    prefered_lang = user.preferred_language
    prefered_lang ||= :en
    result = accepted_versions.detect {|active_version| active_version.language == prefered_lang}
    result ||= accepted_versions.first
    result
  end
end
