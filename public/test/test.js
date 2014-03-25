var assert = chai.assert;

suite('Tests', function(){
  test('Recursividad a izquierdas', function(){
    obj = pl0.parse("a = 3-2-5")
    assert.equal(obj.right.left.type, "-") 
  });

  test('General y asignación', function(){
    obj = pl0.parse("a = 3")
    assert.equal(obj.type, "=")
    assert.equal(obj.left.type, "ID")
    assert.equal(obj.left.value, "a")
    assert.equal(obj.right.type, "NUMBER")
    assert.equal(obj.right.value, "3") 
  });

  test('Suma', function(){
    obj = pl0.parse("2 + 3")
    assert.equal(obj.type, "+")
  });

  test('Multiplicación', function(){
    obj = pl0.parse("2 * 3")
    assert.equal(obj.type, "*") 
  });

  test('División', function(){
    obj = pl0.parse("2 / 3")
    assert.equal(obj.type, "/")
  });

  test('Paréntesis', function(){
    obj = pl0.parse("(2+3) * 3")
    assert.equal(obj.left.type, "+")
  });

});
