#include <stdio.h>

int main() {
    char array[52];
    char i = 0;
    for (char c = 'A'; c <= 'Z'; c++) array[i++] = c;
    for (char c = 'a'; c <= 'z'; c++) array[i++] = c;
    for (int j = 0; j < 52; j++) {
        printf("\\DeclareDocumentCommand{\\tx%c}{O{}}{\\text{%c}}\n\\DeclareDocumentCommand{\\tb%c}{O{}}{\\textbf{%c}}\n\\DeclareDocumentCommand{\\Bf%c}{O{}}{\\relax\\ifmmode\\mathbf{%c}\\else\\text{\\(\\mathbf{%c}\\)}\\fi}\n\\DeclareDocumentCommand{\\rm%c}{O{}}{\\relax\\ifmmode\\mathrm{%c}\\else\\text{\\(\\mathrm{%c}\\)}\\fi}\n\\DeclareDocumentCommand{\\Bb%c}{O{}}{\\IfBlankTF{\\relax\\ifmmode\\mathbb{%c}\\else\\text{\\(\\mathbb{%c}\\)}\\fi}{\\relax\\ifmmode\\mathbb{%c}^{#1}\\else\\text{\\(\\mathbb{%c}^{#1}\\)}\\fi}}\n"
, array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j], array[j]);
        for (int k = 0; k < 52; k++) printf("\\DeclareDocumentCommand{\\tx%c%c}{O{}}{\\text{%c%c}}\n\\DeclareDocumentCommand{\\tb%c%c}{O{}}{\\textbf{%c%c}}\n\\DeclareDocumentCommand{\\Bf%c%c}{O{}}{\\relax\\ifmmode\\mathbf{%c%c}\\else\\text{\\(\\mathbf{%c%c}\\)}\\fi}\n\\DeclareDocumentCommand{\\rm%c%c}{O{}}{\\relax\\ifmmode\\mathrm{%c%c}\\else\\text{\\(\\mathrm{%c%c}\\)}\\fi}\n", array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k], array[j], array[k]);
    }
}