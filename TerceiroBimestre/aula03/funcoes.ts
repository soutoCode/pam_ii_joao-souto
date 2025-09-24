function saudacao(nome: string): string {
    return `Olá, ${nome}!`;
}

console.log(saudacao('Leandro'));

interface Usuario {
    nome: string;
    idade: number;
    email?: string;
}

function exibirUsuario(usuario: Usuario): void {
    console.log(`Nome: ${usuario.nome}`);
    console.log(`Idade: ${usuario.idade}`);
}

exibirUsuario({ nome: 'Aeris', idade: 24 });

function listarNomes(nomes: string[]): void {
    nomes.forEach(nome => console.log(nome));
}

listarNomes(['Karina', 'Ningning', 'Giselle']);