import json
import os
from subprocess import check_output, STDOUT
import re

debug=0

if debug:
    stderr = None
else:
    stderr = open(os.devnull, 'w')

url="https://github.com/yade/trunk.git"
out = check_output(['nix-prefetch-git'] + [url], stderr=stderr)
data = json.loads(out.decode('utf-8'))

fetchgit = '\n'.join((
    'src = fetchgit',
                '      {{',
                '        url = "{url}";',
                '        rev = "{revision}";',
                '        sha256 = "{hash}";',
                '      }};',
)).format(
    url=url,
    revision=data['rev'],
    hash=data['sha256'],
)

file = "daily.nix"

f = open(file)
file_str = f.read()
f.close()

file_str_update = re.sub("src = fetchgit\n.*\{(.*\n){4}.*\};", fetchgit,  file_str, re.DOTALL)

f = open(file, 'w')
f.write(file_str_update)
f.close()


