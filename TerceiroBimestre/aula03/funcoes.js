function saudacao(nome) {
    return `Olá, ${nome}!`;
}
console.log(saudacao('Leandro'));
function exibirUsuario(usuario) {
    console.log(`Nome: ${usuario.nome}`);
    console.log(`Idade: ${usuario.idade}`);
}
exibirUsuario({ nome: 'Aeris', idade: 24 });
function listarNomes(nomes) {
    nomes.forEach(function (nome) { return console.log(nome); });
}
listarNomes(['Karina', 'Ningning', 'Giselle']);
