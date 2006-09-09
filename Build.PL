use Module::Build;
# See perldoc Module::Build for details of how this works

Module::Build->new
    ( module_name     => 'Math::Random::OO',
      create_makefile_pl => "traditional",
      create_readme => 1,
      license         => 'perl',
    requires => {
        perl => 5.006,
        Attribute::Util => 0.02,
        Params::Validate => 0.76,
        # build requires
        Test::Exception => 0.20,
        Test::MockRandom => 0.95,
        Test::More => 0.47,
        Test::Number::Delta => 0.14,
    },
    build_requires => {
    },
	)->create_build_script;
