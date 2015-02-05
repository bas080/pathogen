lunit = {}

lunit.tests = function( name, tests )
  print("TEST: "..name)
  local succes = function( description )
    print( 'succes: '..description )
    return true
  end
  local failed = function( description, expected, value )
    print( 'failed: '..description..'\texpected '..tostring(expected)..' got '..tostring(value) )
    return false
  end
  local unit = {
    ok = function( value, description )
      if value then
        succes( description )
      else
        failed( description, 'true-ish', value )
      end
      return value
    end,
    equal = function( value, expected, description)
      if value == expected then
        succes( description )
      else
        failed( description, expected, value )
      end
      return value
    end,
  }
  return tests( unit )
end

if false then
  --used to test the framewrk itself
  lunit.tests( 'lunit succes', function( unit )
    unit.ok( true, 'true is ok')
    unit.ok( {}, 'table is ok')
    unit.equal( true, true, 'equals true')
    unit.equal( false, false, 'equals false')
    unit.equal( 'hello', 'hello', 'equals string')
    unit.equal( type(''), 'string', 'is type')
  end)
  --fail
  lunit.tests( 'lunit fails', function( unit )
    unit.ok( false, 'true is ok')
    unit.equal( false, true, 'equals true')
    unit.equal( false , {}, 'false equals table')
    unit.equal( true, false, 'equals false')
    unit.equal( 'hello', 'world', 'does not equal string')
  end)
end
