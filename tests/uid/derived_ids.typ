#import "/lib/_lib.typ/tag.typ": _tag_uuid
#import "/lib/_lib.typ/state.typ": _state_uuid
#import "/lib/_lib.typ/record.typ": _record_uuid
#import "/lib/_lib.typ/enum.typ": _enum_uuid
#let factories = (_tag_uuid, _state_uuid, _record_uuid, _enum_uuid)
#assert.eq(factories.map(f => f("same")).dedup().len(), factories.len())
#for f in factories {
  assert.eq(f("same"), f("same"))
  assert.ne(f("same"), f("other"))
}
