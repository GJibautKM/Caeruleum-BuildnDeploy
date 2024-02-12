FROM mcr.microsoft.com/dotnet/runtime:8.0 AS base
USER app
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
RUN git clone https://github.com/GJibautKM/Caeruleum.git
RUN dotnet build "./Caeruleum/Caeruleum.Worker/Caeruleum.Worker.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./Caeruleum/Caeruleum.Worker/Caeruleum.Worker.csproj" -c $BUILD_CONFIGURATION -o /app/publish -p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Caeruleum.Worker.dll"]
