package AWS::Lambda::Toolkit::Config;
  use Moo;
  use YAML::PP;
  use Path::Tiny

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
    YAML::PP->new->load_file($self->config_file);
  });

  sub perl_version {
    my $self = shift;
    return $self->contents->{ perl_version };
  }
1;
