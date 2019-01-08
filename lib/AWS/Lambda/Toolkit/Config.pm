package AWS::Lambda::Toolkit::Config;
  use Moo;
  use YAML::PP;
  use Path::Tiny

  has yaml => (is => 'ro', default => sub { YAML::PP->new });

  has project_dir => (is => 'ro', default => sub {
    Path::Tiny->cwd
  });

  has layers_dir => (is => 'ro', lazy => 1, default => sub {
    my $self = shift;
    path($self->project_dir, 'layers');
  });

  has config_file => (is => 'ro', lazy => 1, default => sub {
    my $self = shift;
    path($self->project_dir, 'lambda-perl.config');
  });

  has contents => (is => 'ro', lazy => 1, default => sub {
    my $self = shift;
    $self->yaml->load_file($self->config_file);
  });

  sub deps_layer_name {
    my $self = shift;
    return 'deps_' . $self->lambda_name;
  }

  sub deps_layer_file {
    my $self = shift;
    
    path($self->layers_dir, $self->deps_layer_name . '.zip');
  }

  sub lambda_name {
    my $self = shift;
    return $self->contents->{ lambda_name };
  }

  sub perl_version {
    my $self = shift;
    return $self->contents->{ perl_version };
  }

  sub region {
    my $self = shift;
    return $self->contents->{ region };
  }

  sub persist {
    my $self = shift;
    $self->yaml->dump_file(
      $self->config_file,
      $self->contents
    );
  }
1;
