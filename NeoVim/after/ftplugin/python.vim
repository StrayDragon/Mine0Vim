" Preserve existing doge settings.
let b:doge_patterns = get(b:, 'doge_patterns', {})
let b:doge_supported_doc_standards = get(b:, 'doge_supported_doc_standards', [])
if index(b:doge_supported_doc_standards, 'reST_custom') < 0
  call add(b:doge_supported_doc_standards, 'reST_custom')
endif

" Set the new doc standard as default.
let b:doge_doc_standard = 'reST_custom'

" Ensure we do not overwrite an existing doc standard.
if !has_key(b:doge_patterns, 'reST_custom')
  let b:doge_patterns['reST_custom'] = [
        \  {
        \    'match': '\m^def\s\+\%([^(]\+\)\s*(\(.\{-}\))\%(\s*->\s*\(.\{-}\)\)\?\s*:',
        \    'tokens': ['parameters', 'returnType'],
        \    'parameters': {
        \      'match': '\m\([[:alnum:]_]\+\)\%(\s*:\s*\([[:alnum:]_.]\+\%(\[[[:alnum:]_[\],[:space:]]*\]\)\?\)\)\?\%(\s*=\s*\([^,]\+\)\)\?',
        \      'tokens': ['name', 'type', 'default'],
        \      'format': ':param {name} {type|!type}: !description',
        \    },
        \    'insert': 'below',
        \    'template': [
        \      '"""',
        \      '!description',
        \      '',
        \      '%(parameters|{parameters})%',
        \      '%(returnType|:rtype {returnType}: !description)%',
        \      '"""',
        \    ],
        \  },
        \]
endif
