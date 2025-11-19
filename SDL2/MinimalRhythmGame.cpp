#include <SDL2/SDL.h>
#include <cstdlib>
#include <ctime>
#include <algorithm>
#include <vector>

const int WINDOW_WIDTH = 400;
const int WINDOW_HEIGHT = 600;
const int RAILS = 4;
const int NOTE_WIDTH = 80;
const int NOTE_HEIGHT = 20;
const int NOTE_SPEED = 5;
const int SPAWN_INTERVAL = 30;
const int HIT_LINE_Y = WINDOW_HEIGHT - 50;
const int HIT_ZONE = 50;

struct Note {
    int rail;
    int y;
};

int main() {
    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window* window = SDL_CreateWindow("Minimal Rhythm Game",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        WINDOW_WIDTH, WINDOW_HEIGHT,
        SDL_WINDOW_SHOWN);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
    std::srand(std::time(nullptr));

    std::vector<Note> notes;
    int frameCount = 0;
    int score = 0;

    bool running = true;
    SDL_Event e;

    Uint32 startTime = SDL_GetTicks();

    while (running) {
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) running = false;
            if (e.type == SDL_KEYDOWN) {
                int keyRail = -1;
                switch (e.key.keysym.sym) {
                    case SDLK_a: keyRail = 0; break;
                    case SDLK_s: keyRail = 1; break;
                    case SDLK_d: keyRail = 2; break;
                    case SDLK_f: keyRail = 3; break;
                }
                if (keyRail != -1) {
                    for (auto it = notes.begin(); it != notes.end(); ++it) {
                        if (it->rail == keyRail) {
                            int distance = std::abs((it->y + NOTE_HEIGHT) - HIT_LINE_Y);
                            if (distance <= HIT_ZONE) {
                                int hitScore = 0;
                                if (distance < 5) hitScore = 300;
                                else if (distance < 15) hitScore = 200;
                                else if (distance < 30) hitScore = 100;
                                else hitScore = 50;
                                score += hitScore;
                                notes.erase(it);
                                break;
                            }
                        }
                    }
                }
            }
        }

        if (frameCount % SPAWN_INTERVAL == 0) {
            notes.push_back({std::rand() % RAILS, 0});
        }

        for (auto &note : notes) note.y += NOTE_SPEED;

        std::erase_if(notes, [](const Note &n){ return n.y > WINDOW_HEIGHT; });

        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);

        for (int i = 0; i < RAILS; i++) {
            SDL_Rect rail = {i * NOTE_WIDTH, 0, NOTE_WIDTH, WINDOW_HEIGHT};
            SDL_SetRenderDrawColor(renderer, 50, 50, 50, 255);
            SDL_RenderFillRect(renderer, &rail);
        }

        for (auto &note : notes) {
            SDL_Rect rect = {note.rail * NOTE_WIDTH + 10, note.y, NOTE_WIDTH - 20, NOTE_HEIGHT};
            SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
            SDL_RenderFillRect(renderer, &rect);
        }

        SDL_Rect hitLine = {0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, 5};
        SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255);
        SDL_RenderFillRect(renderer, &hitLine);
        SDL_RenderPresent(renderer);

        SDL_Delay(16);
        frameCount++;
    }

    Uint32 endTime = SDL_GetTicks();
    float secondsElapsed = (endTime - startTime) / 1000.0f;

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

    printf("Final Score: %d\n", score);
    printf("Time Played: %.2f seconds\n", secondsElapsed);

    return 0;
}