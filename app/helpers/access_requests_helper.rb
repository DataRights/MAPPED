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
end
