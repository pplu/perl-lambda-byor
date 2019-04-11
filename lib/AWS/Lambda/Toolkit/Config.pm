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

  sub function_layer_file {
    my $self = shift;
    path($self->layers_dir, $self->lambda_name . '.zip');
  }

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

  sub perl_runtime_layer {
    my $self = shift;
    return $self->contents->{ perl_runtime_layer };
  }

  sub deps_layer {
    my $self = shift;
    return $self->contents->{ deps_layer };
  }

  sub role {
    my $self = shift;
    return $self->contents->{ role };
  }

  sub handler {
    my $self = shift;
    return $self->contents->{ handler };
  }

  sub env {
    my $self = shift;
    return $self->contents->{ env } // {};
  }

  sub timeout {
    my $self = shift;
    return $self->contents->{ timeout } // 30;
  }

  sub memory {
    my $self = shift;
    return $self->contents->{ memory } // 128;
  }

  sub persist {
    my $self = shift;
    $self->yaml->dump_file(
      $self->config_file,
      $self->contents
    );
  }
1;
