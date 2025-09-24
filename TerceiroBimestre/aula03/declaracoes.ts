let nome: string = 'winter';
let idade: number = 25;
let estaAtivo: boolean = true;

let numeros: number[] = [1, 2, 3, 4, 5];
let nomes: string[] = ['Karina', 'Ningning', 'Giselle'];
let misto: (string | number)[] = ['Karina', 25, 'Giselle', 30];
let misto2: Array<string | number> = ['Karina', 25, 'Giselle', 30];

let pessoa: [string, number] = ['Naevis', 30];

let id: number | string = 123;
id = 'ABC123';

interface Usuario {
    nome: string;
    idade: number;
    email?: string; //opcional
}

let novoUsuario: Usuario = {
    nome: 'Black Mamba',
    idade: 18
};