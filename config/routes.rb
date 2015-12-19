Rails.application.routes.draw do

  root 'static#calendar'

  get 'ok' => 'static#ok'

end
