#!/usr/bin/env ruby

require 'yaml'
require 'json'

def to_point(job)
  feature = nil
  begin
    feature = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [job[:loclongitude], job[:loclatitude]],
      },
      properties: {
        did: job[:did].strip,
        country: "US",
        state: job[:statename].strip,
        city: job[:cityname].strip,
        postalcode: job[:geouszip5].to_s,
        streetaddr: job[:streetaddress1].strip        
      }
    }
  rescue
    feature = nil
  end
  feature
end

def to_featurecollection(jobs)
  {
    type: "FeatureCollection",
    features: jobs.map{|job| to_point job}
  }
end

job_rows = YAML.load_file 'mapped_jobs.yaml'
job_rows.reject! {|job| job.nil?}
featurecollection = to_featurecollection job_rows

File.open('jobs.geojson', 'wb') do |f|
  f.write featurecollection.to_json
end
