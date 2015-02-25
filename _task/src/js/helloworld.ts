class hoge{
    str1 = "hello";

    index(){
        return this.str1 + " world";
    }
}
var obj = new hoge();

console.log( obj.index() );
