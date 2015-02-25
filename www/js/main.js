var hoge = (function () {
    function hoge() {
        this.str1 = "hello";
    }
    hoge.prototype.index = function () {
        return this.str1 + " world";
    };
    return hoge;
})();
var obj = new hoge();
console.log(obj.index());
