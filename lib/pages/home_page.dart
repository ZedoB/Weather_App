import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit/weather_cubit.dart';
import 'package:weather_app/cubits/weather_cubit/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';



class HomePage extends StatelessWidget {

  WeatherModel? weatherData;

  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchPage();
              }));
            },
            icon: const Icon(Icons.search),
          ),
        ],
        title: const Text('Weather App'),
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state){
          if(state is WeatherLoading){
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(state is WeatherSuccess){
            return Success(weatherData: state.weatherModel);
          }
          else if(state is WeatherFailure){
            return const Center(child: Text('Something went wrong'),);
          }
          else{
            return const Default();
          }
        },
      )
    );
  }
}

class Default extends StatelessWidget {
  const Default({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'There is no weather',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            'Start searching now 🔍',
            style: TextStyle(
              fontSize: 30,
            ),
          )
        ],
      ),
    );
  }
}

class Success extends StatelessWidget {
  const Success({
    Key? key,
    required this.weatherData,
  }) : super(key: key);

  final WeatherModel? weatherData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              weatherData!.getThemeColor(),
              weatherData!.getThemeColor()[300]!,
              weatherData!.getThemeColor()[100]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 3,
          ),
          Text(
            BlocProvider.of<WeatherCubit>(context).cityName!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'updated at : ${weatherData!.date.hour
                .toString()}:${weatherData!.date.minute.toString()}',
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(weatherData!.getImage()),
              Text(
                weatherData!.temp.toInt().toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Text('maxTemp :${weatherData!.maxTemp.toInt()}'),
                  Text('minTemp : ${weatherData!.minTemp.toInt()}'),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            weatherData!.weatherStateName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(
            flex: 5,
          ),
        ],
      ),
    );
  }
}
