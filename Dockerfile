# https://hub.docker.com/_/microsoft-dotnet-core
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY *.csproj .
COPY nuget.config .
RUN dotnet restore --configfile nuget.config

# copy everything else and build app
COPY . .
WORKDIR /source
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1	
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "StoreBot.dll"]
