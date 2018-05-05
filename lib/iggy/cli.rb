#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "iggy"

require "inspec"
require "json"
require "thor"

class Iggy::CLI < Thor
  def self.exit_on_failure?
    true
  end

  map %w{-v --version} => "version"

  desc "version", "Display version information", hide: true
  def version
    say("Iggy v#{Iggy::VERSION}")
  end

  class_option :debug,
    :desc    => "Verbose debugging messages",
    :type    => :boolean,
    :default => false

  option :tfstate,
    :aliases => "-t",
    :desc    => "Specify path to the input terraform.tfstate",
    :default => "terraform.tfstate"

  desc "terraform [options]", "Convert terraform.tfstate into an InSpec compliance profile"
  def terraform
    Iggy::Log.level = :debug if options[:debug]
    Iggy::Log.debug "terraform file = #{options[:tfstate]}"

    # hash of generated controls
    generated_controls = Iggy::Terraform.parse(options[:tfstate])
    Iggy::Log.debug "terraform generated_controls = #{generated_controls}"

    # let's just generate a control file with a set of controls for now
    Iggy::Inspec.print_controls(options[:tfstate], generated_controls)
    exit 0
  end

  # desc "terraform_profiles [options]", "Extract the tagged profiles from the Terraform.tfstate"
  # def terraform_profiles
  #   Iggy::Log.level = :debug if options[:debug]
  #   Iggy::Log.debug "terraform profile = #{options[:profile]}"
  #   # hash of tagged compliance profiles
  #   # @compliance_profiles = {}
  #   # Iggy::Log.debug "terraform @compliance_profiles = #{@compliance_profiles}"
  # end

end
