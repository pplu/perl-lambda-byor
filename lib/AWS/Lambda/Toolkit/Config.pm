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

  sub perl_version {
    my $self = shift;
    return $self->contents->{ perl_version };
  }

  sub persist {
    my $self = shift;
    $self->yaml->dump_file(
      $self->config_file,
      $self->contents
    );
  }
1;
