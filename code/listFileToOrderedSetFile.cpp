#include <iostream>
#include <fstream>
#include <set>
#include <string>
#include <algorithm>
#include <cctype>

bool isBlankOrWhitespace(const std::string& line) {
    // Check if the entire line consists of whitespace characters
    return std::all_of(line.begin(), line.end(), [](unsigned char c) {
        return std::isspace(c);
    });
}

void normalizeLineEndings(std::string& line) {
    // Replace Windows-style CRLF (\r\n) with Unix-style LF (\n)
    if (!line.empty() && line.back() == '\r') {
        line.pop_back();
    }
}

int main() {
    std::ifstream inputFile("input.txt");
    std::ofstream outputFile("output.txt");

    if (!inputFile.is_open()) {
        std::cerr << "Error: Could not open input.txt" << std::endl;
        return 1;
    }
    if (!outputFile.is_open()) {
        std::cerr << "Error: Could not open output.txt" << std::endl;
        return 1;
    }

    std::set<std::string> lines;
    std::string line;

    while (std::getline(inputFile, line)) {
        // Normalize line endings (remove trailing \r from \r\n)
        normalizeLineEndings(line);

        // Skip empty lines or lines with only whitespace characters
        if (isBlankOrWhitespace(line)) continue;

        // Insert valid lines into the set (automatically handles duplicates and sorting)
        lines.insert(line);
    }

    // Write the unique, sorted lines to output.txt
    for (const auto& sortedLine : lines) {
        outputFile << sortedLine << '\n';
    }

    inputFile.close();
    outputFile.close();

    std::cout << "Processing complete. Check output.txt for results." << std::endl;
    return 0;
}