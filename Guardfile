
guard 'minitest' do
  watch(%r|^spec/(.*)_spec\.rb|)
  watch(%r|^lib/mobiledoc/(.*)\.rb|) { |m| "spec/document/serialise_spec.rb" }
  # watch(%r|^lib/mobiledoc/(.*)\.rb|) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r|^spec/spec_helper\.rb|)    { "spec" }
end