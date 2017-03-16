require_relative('../../lib/cerberus/default_credentials_provider_chain')
require_relative('../../lib/cerberus/env_credentials_provider')
require_relative('../../lib/cerberus/aws_role_credentials_provider')
require_relative('../fake_url_resolver')

describe Cerberus::DefaultCredentialsProviderChain do

  context "validate default provider chain" do

    it "set env provider and make sure we get that one as the default" do
      ENV[Cerberus::EnvCredentialsProvider::CERBERUS_VAULT_TOKEN_ENV_KEY] = "some_token"
      dcpc = Cerberus::DefaultCredentialsProviderChain.new(FakeUrlResolver.new, FAKE_MD_SVC_URL)
      expect(dcpc.getCredentialsProvider.is_a? Cerberus::EnvCredentialsProvider).to eq true
    end

    it "set no env provider and then we should get an error that there are no providers" do
      ENV[Cerberus::EnvCredentialsProvider::CERBERUS_VAULT_TOKEN_ENV_KEY] = nil
      dcpc = Cerberus::DefaultCredentialsProviderChain.new(FakeUrlResolver.new, FAKE_MD_SVC_URL)
      expect{dcpc.getCredentialsProvider}.to raise_error(Cerberus::Exception::NoValidProviders)
    end

  end # context
end # describe