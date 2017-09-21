RSpec.describe "uaa jobs" do
  let(:jobs) { manifest_with_defaults.fetch("jobs") }

  describe "common job properties" do
    context "job uaa" do
      subject(:job) { jobs.find { |j| j["name"] == "uaa" } }

      describe "route registrar" do
        let(:routes) { job.fetch("properties").fetch("route_registrar").fetch("routes") }

        it "registers the correct uris" do
          expect(routes.length).to eq(1)
          expect(routes.first.fetch('uris')).to match_array([
            "uaa.#{terraform_fixture(:cf_root_domain)}",
            "login.#{terraform_fixture(:cf_root_domain)}",
          ])
        end
      end
    end
  end
end
