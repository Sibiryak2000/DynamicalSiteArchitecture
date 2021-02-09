base:
  {%- if salt.state.sls_exists('vm.'+ grains.id|lower) %}
  '*':
    - vm.{{ grains.id|lower }}
  {%- endif %}
  'G@roles:backend':
    - roles.backend